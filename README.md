# Validation

This package is a copy of the [vapor/validation](https://github.com/vapor/validation) package, without vapor core dependencies in order to run it on iOS.  

You can follow [vapor documentation](https://docs.vapor.codes/3.0/validation/getting-started/) to learn how to use it.  

Finally, I can really advise you to use it as it is, especially on server side where vapor package will be a lot more powerful.



## Difference from Vapor package

The main difference is that it doesn't require the model to conform to `Decodable` in order to make validation working. In this regards, you don't have strings path by default and had to add it when creating your validations in order to see it when displaying errors:

```swift
struct Example {
    let mail: String
    let phone: String
    let password: String
}

extension Example: Validatable {

    static func validations() throws -> Validations<Example> {
        var validations = Validations(Example.self)
        validations.add(\.mail, ["mail"], .mail)
        validations.add(\.phone, ["phone"], .phone)
        validations.add(\.password, ["password"], .count(8...))
        return validations
    }

}
```



It also add a phone validations, as you can see on example below.



## Thanks

I allow myself to thank very much Vapor community for all there works and great packages, which was really a model that I wanted to bring into iOS.
