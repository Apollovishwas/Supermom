import Foundation
//import Alamofire
class AddFoodIntentHandler:NSObject, AddFoodIntentHandling {
    
    
    func handle(intent: AddFoodIntent, completion: @escaping (AddFoodIntentResponse) -> Void) {
        let foodName = intent.food!
        let whom = intent.whom!
        
        let fm = FoodManager(foodinit:foodName , whominit: whom)
        fm.getNutritionData()
        
        
        
        
        
        completion(AddFoodIntentResponse.success(food: intent.food!,whom:intent.whom!))
    }
    
    
    
    
    
}
