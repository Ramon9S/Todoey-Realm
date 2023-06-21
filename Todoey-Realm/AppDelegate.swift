//
//  AppDelegate.swift
//  Todoey
//
//  Created by Ramon Seoane Martin on 3/6/23.
//

import UIKit
import CoreData
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		print(Realm.Configuration.defaultConfiguration.fileURL!)
		
		let data = Data()
		data.name = "Ramón"
		data.age = 30
		
		do {
			
			let realm = try Realm()
			try realm.write {
				realm.add(data)
			}
		} catch {
			print("Error initialising new realm, \(error)")
		}
		return true
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		
		self.saveContext()
	}
	
	
	// MARK: - Core Data stack
	lazy var persistentContainer: NSPersistentContainer = {
	
		let container = NSPersistentContainer(name: "DataModel")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {

				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	
	// MARK: - Core Data Saving support

	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}

	
	// MARK: UISceneSession Lifecycle
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}


}

