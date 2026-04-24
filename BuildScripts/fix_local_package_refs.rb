#!/usr/bin/env ruby
# frozen_string_literal: true

project_root = File.expand_path("..", __dir__)
pbxproj_path = File.join(project_root, "Github.xcodeproj", "project.pbxproj")
schemes_path = File.join(project_root, "Github.xcodeproj", "xcshareddata", "xcschemes")

unless File.exist?(pbxproj_path)
  warn "warning: project file not found at #{pbxproj_path}"
  exit 0
end

contents = File.read(pbxproj_path)

package_refs = {
  "CommonData" => contents[/([A-F0-9]+) \/\* XCLocalSwiftPackageReference "Packages\/CommonData" \*\//, 1],
  "GithubAPI" => contents[/([A-F0-9]+) \/\* XCLocalSwiftPackageReference "Packages\/GithubAPI" \*\//, 1]
}

updated = contents.dup

package_refs.each do |product_name, package_ref_id|
  next unless package_ref_id

  updated = updated.sub(
    Regexp.new(
      "(\\t\\t[A-F0-9]+ \\/\\* #{Regexp.escape(product_name)} \\*\\/ = \\{\\n" \
      "\\t\\t\\tisa = XCSwiftPackageProductDependency;\\n)(?!\\t\\t\\tpackage = )"
    ),
    "\\1\t\t\tpackage = #{package_ref_id} /* XCLocalSwiftPackageReference \"Packages/#{product_name}\" */;\n"
  )
end

File.write(pbxproj_path, updated) if updated != contents

def buildable_reference_attributes(scheme_contents, blueprint_name)
  block = scheme_contents[
    /<BuildableReference\b(?:(?!<\/BuildActionEntry>).)*BlueprintName = "#{Regexp.escape(blueprint_name)}"(?:(?!<\/BuildActionEntry>).)*<\/BuildableReference>/m
  ]
  return nil unless block

  {
    blueprint_identifier: block[/BlueprintIdentifier = "([^"]+)"/, 1],
    buildable_name: block[/BuildableName = "([^"]+)"/, 1],
    referenced_container: block[/ReferencedContainer = "([^"]+)"/, 1]
  }
end

Dir.glob(File.join(schemes_path, "*.xcscheme")).each do |scheme_path|
  scheme_contents = File.read(scheme_path)
  testables_block = scheme_contents[/<Testables>(.*?)<\/Testables>/m, 1]
  next unless testables_block

  has_github_tests = testables_block.include?('BlueprintName = "GithubTests"')
  has_github_ui_tests = testables_block.include?('BlueprintName = "GithubUITests"')
  next if has_github_tests && has_github_ui_tests

  references = [
    ["GithubTests", buildable_reference_attributes(scheme_contents, "GithubTests")],
    ["GithubUITests", buildable_reference_attributes(scheme_contents, "GithubUITests")]
  ].filter_map do |blueprint_name, attributes|
    next unless attributes

    <<~XML.chomp
               <TestableReference skipped = "NO">
                  <BuildableReference
                     BuildableIdentifier = "primary"
                     BlueprintIdentifier = "#{attributes[:blueprint_identifier]}"
                     BuildableName = "#{attributes[:buildable_name]}"
                     BlueprintName = "#{blueprint_name}"
                     ReferencedContainer = "#{attributes[:referenced_container]}">
                  </BuildableReference>
               </TestableReference>
    XML
  end

  next if references.empty?

  replacement = "<Testables>\n#{references.join("\n")}\n      </Testables>"
  updated_scheme_contents = scheme_contents.sub(
    /<Testables>.*?<\/Testables>/m,
    replacement
  )

  File.write(scheme_path, updated_scheme_contents) if updated_scheme_contents != scheme_contents
end
