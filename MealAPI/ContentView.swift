import SwiftUI

struct Category: Codable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}

struct Meal: Decodable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strInstructions: String
    let strCategory: String?
    let strArea: String
    let strTags: String?
    let strYoutube: String?
    let strSource: String?
    let dateModified: String?
    
    var id: String {
        idMeal
    }
}

struct ContentView: View {
    @State private var categories = [Category]()
    @State private var searchText = ""
    @State private var meals = [Meal]()
    @State private var isSearching = false
    
    var body: some View {
        
        NavigationView {
            List(categories, id: \.idCategory) { category in
                NavigationLink(destination: CategoryDetailView(category: category)) {
                    HStack {
                        RemoteImage(url: category.strCategoryThumb)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .padding()
                        Text(category.strCategory)
                            .font(.headline)
                            .padding(.trailing, 10)
                    }
                }
            }
            .navigationBarTitle(Text("Meal Categories")).foregroundColor(Color.black)
            
            .onAppear(perform: loadData)
        }
        
        
    }
    
    func loadData() {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php") else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(CategoryResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.categories = decodedResponse.categories
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct CategoryDetailView: View {
    let category: Category
    @State private var meals = [Meal]()
    
    var body: some View {
        ScrollView {
            VStack {
                RemoteImage(url: category.strCategoryThumb)
                    .frame(width: 200, height: 200)
                    .padding()
                Text(category.strCategory)
                    .font(.title)
                    .padding()
                Text(category.strCategoryDescription)
                    .font(.body)
                    .padding()
                if !meals.isEmpty {
                    List(meals) { meal in
                        NavigationLink(destination: MealDetailView(meal: meal)) {
                            HStack {
                                RemoteImage(url: meal.strMealThumb)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .padding()
                                Text(meal.strMeal)
                                    .font(.headline)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                } else {
                    Text("Loading meals...")
                        .font(.headline)
                }
            }
            .onAppear(perform: loadMeals)
        }
        .navigationBarTitle(Text(category.strCategory), displayMode: .inline)
    }
    
    func loadMeals() {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category.strCategory)") else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Meal].self, from: data){
                    DispatchQueue.main.async {
                                            self.meals = decodedResponse
                                        }
                                        return
                                    }
                                }
                                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                            }.resume()
                    }
}

struct MealDetailView: View {
    let meal: Meal
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                RemoteImage(url: meal.strMealThumb)
                    .frame(width: 300, height: 300)
                
                Text(meal.strMeal)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                if let instructions = meal.strInstructions, !instructions.isEmpty {
                    Text(instructions)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                if let youtubeURL = URL(string: meal.strYoutube ?? "") {
                    Button(action: {
                        UIApplication.shared.open(youtubeURL)
                    }) {
                        HStack {
                            Image(systemName: "play.rectangle.fill")
                                .foregroundColor(.red)
                            Text("Watch on YouTube")
                                .foregroundColor(.red)
                                .font(.headline)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 2)
                        )
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle(Text(meal.strMeal), displayMode: .inline)
    }
}


struct RemoteImage: View {
    let url: String
    @State private var image: Image = Image(systemName: "photo")
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onAppear(perform: loadImage)
    }
    
    func loadImage() {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.image = Image(uiImage: UIImage(data: data) ?? UIImage())
            }
        }.resume()
    }
}

struct CategoryResponse: Codable {
let categories: [Category]
}

struct MealResponse: Decodable {
let meals: [Meal]
}

struct ContentView_Previews: PreviewProvider {
static var previews: some View {
ContentView()
}
}



