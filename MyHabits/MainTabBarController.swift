
import UIKit

class MainTabBarController: UITabBarController {

    //MARK: - PROPs
    let firstVC = HabitsViewController()
    let secondVC = InfoViewController()

    
    //MARK: - INITs
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
        
        //красим все бары в один цвет
        //UINavigationBar.appearance().backgroundColor = HabitColor.navBar
        //UIApplication.shared.statusBarUIView?.backgroundColor = UIColor.HabitColor.navBar
        UITabBar.appearance().tintColor = HabitColor.purple
        UITabBar.appearance().backgroundColor = HabitColor.tabBar
    }
    
    
    //MARK: - METHODs
    func setupControllers() {
        firstVC.tabBarItem.title = "Привычки"
        firstVC.tabBarItem.image = UIImage(systemName: "rectangle.grid.1x2.fill")
        firstVC.navigationItem.title = "Сегодня"
        secondVC.tabBarItem.title = "Информация"
        secondVC.tabBarItem.image = UIImage(systemName: "info.circle.fill")
        secondVC.navigationItem.title = "Информация"
        let firstNavigationVC = UINavigationController(rootViewController: firstVC)
        let secondNavigationVC = UINavigationController(rootViewController: secondVC)
        viewControllers = [firstNavigationVC, secondNavigationVC]
    }
}
