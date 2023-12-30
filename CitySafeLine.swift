import Foundation

class Contact {
    var name:String
    var contactNum:[String]
    var category:String?

    init(name:String, contactNum:[String], category:String){
        self.name = name
        self.contactNum = contactNum
        self.category = category
    }
}

func saveContactsToFile() {
    let FILE_NAME = "contacts.txt"
    let DESKTOP_PATH = FileManager.default.currentDirectoryPath
    let FILE_PATH = DESKTOP_PATH + "\\" + FILE_NAME

    var CONTACTS_STRING = ""
    for contact in contacts {
        let CONTACT_INFO = "\(contact.name),\(contact.contactNum.joined(separator: ",")),\(contact.category ?? "")"
        CONTACT_STRING.append(CONTACT_INFO + "\n")
    }

    do {
        try CONTACT_STRING.write(toFile: FILE_PATH, atomically: false, encoding: .utf8)
        
    } catch {
        print("Error saving contacts to \(FILE_NAME): \(error.localizedDescription)")
    }
}

func loadContactsFromFile() -> [Contact] {
    let FILE_NAME = "contacts"
    let DESKTOP_PATH = FileManager.default.currentDirectoryPath
    let FILE_PATH = DESKTOP_PATH + "\\" + FILE_NAME
    
    do {

        let CONTACTS_STRING = try String(contentsOfFile: FILE_PATH, encoding: .utf8)
        
        let CONTACT_LINES = CONTACTS_STRING.components(separatedBy: "\n")
        
        var loadedContacts = [Contact]()
        
        for line in CONTACT_LINES {
            let CONTACT_COMPONENTS = line.components(separatedBy: ",")
            if CONTACT_COMPONENTS.count >= 2 {
                let name = CONTACT_COMPONENTS[0]
                let contactNums = CONTACT_COMPONENTS[1].components(separatedBy: ",")
                let category = CONTACT_COMPONENTS.count > 2 ? CONTACT_COMPONENTS[2] : ""
                let contact = Contact(name: name, contactNum: contactNums, category: category)
                loadedContacts.append(contact)
            }
        }
        
        return loadedContacts
    } catch {
        print("Error loading contacts from \(FILE_NAME): \(error.localizedDescription)")
        return []
    }
}

var contacts: [Contact] = []

print("Welcome To CitySafeLine")
contacts = loadContactsFromFile()
let CURRENT_DIRECTORY = FileManager.default.currentDirectoryPath

print("Current working directory: \(CURRENT_DIRECTORY)")
while(true){
    print("\n1 View Hotlines\n2 Add Hotline\n3 Update Hotline\n4 Search Hotline\n5 Remove Hotline\n0 Exit")
    if let INPUT = readLine() {
        switch(INPUT) {
            case "1":
                for contact in contacts {
                    print("Name: \(contact.name)")
                    print("Contact No.: \(contact.contactNum)")
                    print("Category: \(contact.category ?? "N/A")\n")
                }
            case "2":
                print("Contact Name: ")
                if let CONTACT_NAME = readLine() {
                    print("Contact No.: ")
                    if let CONTACT_NUMBER = readLine() {
                        print("Contact Category: ")
                        if let CONTACT_CAT = readLine() {
                            contacts.append(Contact(name: CONTACT_NAME, contactNum: [CONTACT_NUMBER], category: CONTACT_CAT))
                            saveContactsToFile()
                        } else {
                            print("Invalid input for Contact Category.")
                        }
                    } else {
                        print("Invalid input for Contact No.")
                    }
                } else {
                    print("Invalid input for Contact Name.")
                }
            case "3":
                print("Enter Contact Name to be updated: ")
                    if let CON_NAME = readLine() {
                        var contactFound = false 
                        
                        for contact in contacts {
                            if contact.name == CON_NAME {
                                print("Enter the new Contact Number: ")
                                if let NEW_CONT_NUM = readLine() {
                                    
                                    contact.contactNum.append(NEW_CONT_NUM)
                                    print("Contact Details updated.")
                                    contactFound = true 
                                    break 
                                } else {
                                    print("Invalid input for the new contact number.")
                                }
                            }
                        }
                        
                        if !contactFound {
                            print("Contact with the name \(CON_NAME) not found.")
                        }
                    }
            case "4":
                print("Enter the category to search for contacts: ")
                    if let SEARCH_CATEGORY = readLine() {
                        var contactsInCategory = [Contact]()
                        
                        for contact in contacts {
                            if let CONTACT_CATEGORY = contact.category, CONTACT_CATEGORY.lowercased() == SEARCH_CATEGORY.lowercased() {
                                contactsInCategory.append(contact)
                            }
                        }
                        
                        if contactsInCategory.isEmpty {
                            print("No contacts found in category: \(SEARCH_CATEGORY)")
                        } else {
                            print("Contacts in category: \(SEARCH_CATEGORY)")
                            for contact in contactsInCategory {
                                print("Name: \(contact.name)")
                                print("Contact Numbers: \(contact.contactNum)")
                            }
                        }
                    }
            case "5":
                print("Enter Contact Name to be removed: ")
                    if let CON_NAME = readLine() {
                        var indexToRemove: Int?
                        for (index, contact) in contacts.enumerated() {
                            if contact.name == CON_NAME {
                                indexToRemove = index
                                break
                            }
                        }
                        if let INDEX = indexToRemove {
                            contacts.remove(at: INDEX)
                            saveContactsToFile()
                            print("\(CON_NAME) has been removed.")
                        } else {
                            print("\(CON_NAME) not found in contacts.")
                        }
                    }
            case "0":
                print("Thank you for using CitySafeLine, Goodbye!")
                exit(0)
            default:
                print("Invalid input, Try again")
        }
    }
}
