# Moya-APIBase
基于离散型接口设计，对 Moya 进行封装。

参考 onevcat [面向协议编程与 Cocoa 的邂逅 (下)](https://onevcat.com/2016/12/pop-cocoa-2/)

### 做个对比
---

先看 MoyaMapper 的使用场景
```Swift
// 使用了 MoyaMapper
provider.request(.city("101220101"), ) { result in
    switch result {
    case .success(let response):
        // 指定了是对象、指定了 WeatherInfoModel
        let value = response.mapObject(WeatherInfoModel.self)
        // 指定了是数组
        // let value = response.mapArray(WeatherInfoModel.self)
    case .failure(let error):
        ()
    }
}
```
1. 需要提供额外的信息(WeatherInfoModel)，信息变动时，代码需要变更。
1. 只支持 JSON 数据格式，对于特殊的格式，无能为力。
1. 聚合型接口，在面对接口返回数据类型多样化时，同样需要提供额外数据，改动都是在业务层。

---

再来看看 Moya-APIBase 的使用场景
```Swift
// 使用 Moya-APIBase
WeatherService().activate(parameter: "101220101") { result in
    switch result {
    case .success(let value):
        // data 即为 WeatherInfoModel
        print(value.data ?? "请求成功")
    case .failure(let error):
        ()
    }
}
```
1. 所有的信息，都封装在 Service 层，无需在业务层显式声明任何额外信息。
1. 离散型接口设计，每个接口，都可以拥有自己独立的 Parser，能够处理接口返回数据多样化等复杂的问题。
1. 基于抽象流程，适用场景极广。


### 设计
---
对网络资源的加载，可以大致抽象为这么一个流程：

1. 信息的收集（目标地址、参数）
1. 数据的加载（发起网络请求）
1. 响应数据的解析

用协议来抽象：  
* `InfoType`：负责信息收集  
* `EngineType`：负责数据加载  
* `ParserType`：负责对响应数据进行解析  
* `ServiceType`：最后需要 ServiceType 对整个抽象流程进行封装  

ServiceType 激活之后，会获取 InfoType 进行二次加工。   
加工后的资源作为 EnginType 的输入，启动引擎。   
引擎获得数据并加工后，作为 ParserType 的输入，开始解析。   
最后 ServieType 将 ParserType 解析得到的数据再次加工，并作为最终结果在回调中递交给开发者。   

整个过程中，所有的操作都在看不见的网络层中执行，上层没有任何感知，将网络层和业务层的耦合降至最低。经过多次加工，得到我们的目标数据。



