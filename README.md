## 城市选择器

网上搜了一圈，就没找到好用的城市选择器

要么代码臃肿，要么各种崩溃，所以自己写一个吧

风格的话，看了几十个app，还是滴滴的设计最合理，所以按照滴滴的风格做一个，

<img src="https://raw.githubusercontent.com/CaledoniaProject/DidiCityPickerViewController/master/contrib/screen.jpg" width="328px">

## 用法

准备工作，

```
1. 拖拽 `src/CityPickerViewController/` 到你的项目目录，
2. 修改 `CityPickerViewController.m`，根据你的 navigationBar 风格，修改颜色
3. 修改 info.Plist，开启定位功能
```

下面开始使用这个 ViewController，首先实现 `CityPickerDelegate`

```
#import <UIKit/UIKit.h>
#import "CityPickerViewController.h"

@interface ViewController : UIViewController <CityPickerDelegate>

@end
```

然后实现对应的函数，

```
- (void)didPickCity:(NSString *)cityName
{
    self.cityLabel.text = cityName;
}
```

设置好代理，e.g

```
- (IBAction)didTapCityButton:(id)sender {
    CityPickerViewController *vc = [[CityPickerViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
```

如果还是有疑问，看 example 目录的测试代码即可

