# CCInit

CCInit is CatCyborg's boilerplates for iOS, Ruby on Rails, and Middleman static site projects. It is a summary of things CatCyborg copy-pasted when she starts doing sudden projects that come out of the rainbow land. Most of the codes here are for CRUD-ing or implementing mockups. So, CCInit might not be useful for you, but feel free to check it out anyway.

# Usage

Clone this project.

```
git clone https://github.com/catcyborg/CCInit.git
```

Then pick a project template to be initialized.

## iOS

The sample project contains...

- Preferred project folder structure
- Classes and categories for helping out consuming API and CRUD-ing
    - This includes typical infinite scroll or load more items in a list horizontally or vertically.

Right now, there aren't any samples on how to use the classes and categories. More samples will be included under the [view controllers folder](https://github.com/catcyborg/CCInit/tree/master/ios/CrudApiConsumerApp/CrudApiConsumerApp/Code/ViewControllers) soon!.

## Rails

```
rails new rainbow_dog_api -J -D postgres -T -m rails/api_with_admin/template.rb
```

Replace `rainbow_dog_api` with your app name, of course.

## Middleman

TODO


# Contributing

Feel free to submit bugs, suggestions, or contribution through [pull requests](https://github.com/catcyborg/CCInit/pulls).

# License

CCInit is released under the [MIT License](http://opensource.org/licenses/MIT).
