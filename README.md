# ValidationsKit

The purpose of this kit is to bring [vapor/validation](https://github.com/vapor/validation) package to iOS, by removing Vapor core dependencies from it.

## Example

Will try to add validations to a `User` model, in order to be conform for a registration process for example.  
We first have to describe it as we usually do. We also make it conform to `Codable` and `Refletable` so it can naturally get path from the object

```swift
struct User {
    let mail: String
    let phone: String
    let password: String
    let website: String?
    let twitter: String?
}

extension User: Codable {}
extension User: Reflectable {}
```

Then we have to make this model conform to `Validatable` protocol by adding the `validations()` function. This return a `Validations` object for our model and allow us to add `Validator`s to it.  
Like the Vapor package, there's already some `Validator`s you can use (such as `mail`, `count`, `empty` ...) or you can define you own validation rule through a closure:

```swift
extension User: Validatable {

    static func validations() throws -> Validations<User> {
        var validations = Validations(User.self)

        // 'mail' should be a valid mail address.
        validations.add(\.mail, .mail)

        // 'phone' should be a valid phone number.
        validations.add(\.phone, .phone) 

        // 'password' should have more than 8 characters.
        validations.add(\.password, .count(8...))

        // 'website' should be nil or be a valid url.
        validations.add(\.website, .nil || .url)

        // 'twitter' should be nil or began by '@'.
        validations.add(\.twitter, validator: { twitter in
        	guard let twitter = twitter else { return }
            guard twitter.first != "@" else { return }
            throw BasicValidationError("isn't a valid Twitter username")
        })
        
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

Or you can validate only specified fields:

```swift
try valid.validate(at: \User.mail, \User.password)
```

Finally, you can now define your own message to be thrown in a case of validations failure, which can be handy to pass some localised string or just display some custom message to end user:

```swift
struct User: Validatable {
    let age: Int
    
    static func validations() throws -> Validations<User> {
        var validations = Validations(User.self)
        
        validations.add(\.age, .range(..< 12)) { age in
            "You have to be at most 12 for doing this, \(age) is too old for that stuff..."
        }
        
        return validations
    }

}

do {
    try User(age: 42)
} catch {
    print("\(error)") // "You have to be at most 12 for doing this, 42 is too old for that stuff..."
}
```

You can also take a look to a demo application in the `ValidationsKitDemo` directory.

## Installation
### Swift Package Manager

Add the GitHub link in you `Package.swift` as a dependencies:

```swift
.package(url: "https://github.com/amoriarty/ValidationsKit", from: "1.3.0"),
```

Add the dependency to your target:

```swift
.target(name: "your_target_name", dependencies: ["ValidationsKit"]),
```

Then update you project with:

```sh
$ swift package update
```

### Cocoapods

Simply add this line in you pods dependencies:

```ruby
pod 'ValidationsKit', '~> 1.3.0'
```

## Thanks

I allow myself to thank very much Vapor community for all there works and great packages, which was really a model that I wanted to bring into iOS.
