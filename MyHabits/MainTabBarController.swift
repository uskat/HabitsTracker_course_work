
import UIKit

class MainTabBarController: UITabBarController {

    let firstVC = HabitsViewController()
    let secondVC = InfoViewController()

    
//MARK: ==================================== INITs ====================================
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
        
        //красим все бары в один цвет
        UINavigationBar.appearance().backgroundColor = colorOfNavBar
        //UIApplication.shared.statusBarUIView?.backgroundColor = colorOfNavBar
        UITabBar.appearance().tintColor = habitPurpleColor
        UITabBar.appearance().backgroundColor = colorOfTabBar
        
    }
    
    
//MARK: ================================== ViewITEMs ==================================
    func setupControllers() {
        firstVC.tabBarItem.title = "Привычки"
        firstVC.tabBarItem.image = UIImage(systemName: "rectangle.grid.2x2")
        //firstVC.navigationItem.title = "Feed"
        secondVC.tabBarItem.title = "Информация"
        secondVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        secondVC.navigationItem.title = "Информация"
        let firstNavigationVC = UINavigationController(rootViewController: firstVC)
        let secondNavigationVC = UINavigationController(rootViewController: secondVC)
        viewControllers = [firstNavigationVC, secondNavigationVC]
    }
    
    
//MARK: =================================== METHODs ===================================

}
