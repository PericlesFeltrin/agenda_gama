import UIKit

class Contato: NSObject, NSCoding {
    // MARK: Properties
    
    var name: String
    var email: String
    var telefone: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("contatos")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let emailKey = "email"
        static let telefoneKey = "telefone"
        static let photoKey = "photo"
        static let ratingKey = "rating"
    }
    
    // MARK: Initialization
    
    init?(name: String, email: String, telefone: String, photo: UIImage?, rating: Int) {
        // Initialize stored properties.
        self.name = name
        self.email = email
        self.telefone = telefone
        self.photo = photo
        self.rating = rating
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(email, forKey: PropertyKey.emailKey)
        aCoder.encodeObject(telefone, forKey: PropertyKey.telefoneKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let email = aDecoder.decodeObjectForKey(PropertyKey.emailKey) as! String
        let telefone = aDecoder.decodeObjectForKey(PropertyKey.telefoneKey) as! String
        
        // Because photo is an optional property of Contato, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
        
        // Must call designated initializer.
        self.init(name: name, email: email, telefone: telefone, photo: photo, rating: rating)
    }
    
}