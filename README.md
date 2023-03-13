# FetchRewardsIOS

This SwiftUI code is a meal app that uses the mealdb.com API to display meal categories and their respective meals. The code consists of three view structs: ContentView, CategoryDetailView, and MealDetailView.

ContentView displays a list of meal categories obtained from the API. When a category is tapped, the user is taken to CategoryDetailView.

CategoryDetailView displays a meal category's image, name, description, and a list of meals belonging to that category. When a meal is tapped, the user is taken to MealDetailView.

MealDetailView displays a meal's image, name, instructions, and a button to open the meal's YouTube video, if it exists.

There is also a RemoteImage struct that loads and displays images from a URL.

The code uses URLSession.shared.dataTask to make API requests, and JSONDecoder to decode JSON responses. The API responses are decoded into Codable structs: Category and Meal. The meal categories API is decoded into a CategoryResponse struct that contains an array of Category objects.

The app also uses @State properties to hold the meal categories, meals, search text, and isSearching flag. The loadData and loadMeals functions make API requests to fetch the meal categories and meals, respectively.

Overall, this app provides an easy-to-use interface for browsing and searching meal categories and their respective meals, as well as viewing detailed information about each meal.

*NOTE* -> Images and details of the Meals are not loading all the time as there is an issue with the API.
