##MKNetwork
这是用`Swift语言`开发的网络数据访问的框架
##如何使用

* 将MKNetwork文件夹下的所有文件拖入到您的项目即可



##使用细节

###直接调用requestJSON()函数

```swift
let net = MKNetwork()
net.requestJSON(.GET, urlString, nil) { (result, error) -> () in}
```
