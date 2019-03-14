# ValidationsKit

The purpose of this kit is to bring [vapor/validation](https://github.com/vapor/validation) package to iOS, by removing Vapor core dependencies from it.

## Example

Will try to add validations to a `User` model, in order to be conform for a registration process for example.  
We first have to describe it as we usually do.

```swift
struct User {
    let mail: String
    let phone: String
    let password: String
    let website: String?
    let twitter: String?
}
```

Then we have to make this model conform to `Validatable` protocol by adding the `validations()` function. This return a `Validations` object for our model and allow us to add `Validator`s to it.  
Like the Vapor package, there's already some `Validator`s you can use (such as `mail`, `count`, `empty` ...) or you can define you own validation rule through a closure:

```swift
extension User: Validatable {

    static func validations() throws -> Validations<User> {
        var validations = Validations(User.self)

        // 'mail' should be a valid mail address.
        validations.add(\.mail, ["mail"], .mail)

        // 'phone' should be a valid phone number.
        validations.add(\.phone, ["phone"], .phone) 

        // 'password' should have more than 8 characters.
        validations.add(\.password, ["password"], .count(8...))

        // 'website' should be nil or be a valid url.
        validations.add(\.website, ["website"], .nil || .url)

        // 'twitter' should be nil or began by '@'.
        validations.add(\.twitter, at: ["twitter"]) { twitter in
        	guard let twitter = twitter else { return }
            guard twitter.first != "@" else { return }
            throw BasicValidationError("isn't a valid Twitter username")
        }
        return validations
    }

}
```

We now have a model setup and we can now call the `validate()` method on it.

```swift
let valid = User(mail: "example@example.com", phone: "++3642424242", password: "somepassword", website: nil, twitter: nil)
do { try valid.validate() }
catch {
	// Will never be executed because our model is valid.
}

let invalidWebsite = User(mail: "example@example.com", phone: "++3642424242", password: "somepassword", website: "notValidUrl", twitter: nil)
do { try invalidWebsite.validate() }
catch {
	print("\(error)") // 'website' isn't nil or isn't a valid url.
}
```

You also can take a look to a demo application in the `ValidationsKitDemo` directory, using Cocoapods.

## Installation
### Cocoapods

Simply add this line in you pods dependencies:

```ruby
	pod 'ValidationsKit', '~> 1.0'
```

### Swift Package Manager

Add the GitHub link in you `Package.swift` as a dependencies:

```swift
    .package(url: "https://github.com/amoriarty/ValidationsKit", from: "1.0.0"),
```

Then update you project with:

```sh
$ swift package update
```

## Difference from Vapor package

The main difference from Vapor package is that it doesn't include the `Reflectable` system, that allow you to make your model conform both to `Decodable` and `Reflectable` to avoid typing the key path to show in case of errors, which can lead to errors is variable are rename in the future.

## Thanks

I allow myself to thank very much Vapor community for all there works and great packages, which was really a model that I wanted to bring into iOS.
