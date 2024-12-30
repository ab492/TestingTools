<p align="center">
  <img src="TestingTools/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png" alt="Testing Tools Icon" width="200" />
</p>

# Testing Tools Xcode Extension
Testing Tools is an extension for Xcode designed to make test-driven development smoother. Sometimes, you may want to create the skeleton of an object that doesn’t exist yet (frame-first); Testing Tools will generate an object from your frame. Other times, you might want to manage a to-do list of tests to add; Testing Tools allows you to mark them as ‘in progress’ or ‘done’.

## Important Notes on Developing Xcode Extensions
- It's not documented anywhere, but to test your extension you need to 'Embed and Sign' the `XcodeKit.framework` on the extension target. 
- As per [NSHipster](https://nshipster.com/xcode-source-extensions/), I added my frameworks path to 'Framework Search Paths' in 'Build Settings' to allow `XcodeKit` to show up in tests.
- If you want to test a file in the `TestingToolsExtension`, you have to change its Target Membership to include `TestingToolsTests` or the tests won't compile. I can't work out why this is the case, but a few examples online do the same.

## Useful Resources for Xcode Extensions

- [Working with XcodeKit by Aryaman Sharda](https://www.youtube.com/watch?v=hsX-b7lobF0)
- [NSHipster Xcode Source Extensions](https://nshipster.com/xcode-source-extensions/)
- [Source editor extensions starting guide](https://kowei-chen.medium.com/xcode-extension-1-5-starting-guide-519a95bdc865)

## App Icon

You can find the source for the app icon [here](https://icon.kitchen/i/H4sIAAAAAAAAAzWQwU7DMAyGXwWZaw8bMJB6nRhXhHpDaHITJ43m1lWajlXT3h0nZTkk9h%2Fni39f4Yw80wT1FSzGU9NRT1A75IkqcH7PYcSY8vVEeoAlhzMnqCAYGVQYGRcOUzqitUfTkTnBrYLWN8uoIPARbaAhP2j9xz1RnBGWuNWKx9dNu3UvWlCkpyxtNm9ojEo4eFbM9nmnUHeHmv%2BuikSX3FfTlOwgK91hH3hR%2FUtaSfJwYLrkFoQt1CnOai4k5GDWrMDfnSOTdBRATGdMVIif6isMPkOTjNrKroIYfKff5FDpSfo1ZnJFLbR9NpO9uLLyUHqxM%2BdZf6svGyXYPEaZdP%2BlVvcejWY%2Ftz%2B4QZLhlgEAAA%3D%3D).