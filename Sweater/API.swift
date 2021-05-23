// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetCityByIdQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetCityById($cityId: [String!]) {
      getCityById(id: $cityId, config: {units: metric, lang: en}) {
        __typename
        id
        name
        weather {
          __typename
          summary {
            __typename
            description
          }
          temperature {
            __typename
            actual
            feelsLike
            min
            max
          }
          wind {
            __typename
            speed
          }
          clouds {
            __typename
            humidity
          }
          timestamp
        }
      }
    }
    """

  public let operationName: String = "GetCityById"

  public var cityId: [String]?

  public init(cityId: [String]?) {
    self.cityId = cityId
  }

  public var variables: GraphQLMap? {
    return ["cityId": cityId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getCityById", arguments: ["id": GraphQLVariable("cityId"), "config": ["units": "metric", "lang": "en"]], type: .list(.object(GetCityById.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getCityById: [GetCityById?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "getCityById": getCityById.flatMap { (value: [GetCityById?]) -> [ResultMap?] in value.map { (value: GetCityById?) -> ResultMap? in value.flatMap { (value: GetCityById) -> ResultMap in value.resultMap } } }])
    }

    public var getCityById: [GetCityById?]? {
      get {
        return (resultMap["getCityById"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [GetCityById?] in value.map { (value: ResultMap?) -> GetCityById? in value.flatMap { (value: ResultMap) -> GetCityById in GetCityById(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [GetCityById?]) -> [ResultMap?] in value.map { (value: GetCityById?) -> ResultMap? in value.flatMap { (value: GetCityById) -> ResultMap in value.resultMap } } }, forKey: "getCityById")
      }
    }

    public struct GetCityById: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["City"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("weather", type: .object(Weather.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, name: String? = nil, weather: Weather? = nil) {
        self.init(unsafeResultMap: ["__typename": "City", "id": id, "name": name, "weather": weather.flatMap { (value: Weather) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var weather: Weather? {
        get {
          return (resultMap["weather"] as? ResultMap).flatMap { Weather(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "weather")
        }
      }

      public struct Weather: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Weather"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("summary", type: .object(Summary.selections)),
            GraphQLField("temperature", type: .object(Temperature.selections)),
            GraphQLField("wind", type: .object(Wind.selections)),
            GraphQLField("clouds", type: .object(Cloud.selections)),
            GraphQLField("timestamp", type: .scalar(Int.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(summary: Summary? = nil, temperature: Temperature? = nil, wind: Wind? = nil, clouds: Cloud? = nil, timestamp: Int? = nil) {
          self.init(unsafeResultMap: ["__typename": "Weather", "summary": summary.flatMap { (value: Summary) -> ResultMap in value.resultMap }, "temperature": temperature.flatMap { (value: Temperature) -> ResultMap in value.resultMap }, "wind": wind.flatMap { (value: Wind) -> ResultMap in value.resultMap }, "clouds": clouds.flatMap { (value: Cloud) -> ResultMap in value.resultMap }, "timestamp": timestamp])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var summary: Summary? {
          get {
            return (resultMap["summary"] as? ResultMap).flatMap { Summary(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "summary")
          }
        }

        public var temperature: Temperature? {
          get {
            return (resultMap["temperature"] as? ResultMap).flatMap { Temperature(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "temperature")
          }
        }

        public var wind: Wind? {
          get {
            return (resultMap["wind"] as? ResultMap).flatMap { Wind(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "wind")
          }
        }

        public var clouds: Cloud? {
          get {
            return (resultMap["clouds"] as? ResultMap).flatMap { Cloud(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "clouds")
          }
        }

        public var timestamp: Int? {
          get {
            return resultMap["timestamp"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "timestamp")
          }
        }

        public struct Summary: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Summary"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(description: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Summary", "description": description])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }
        }

        public struct Temperature: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Temperature"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("actual", type: .scalar(Double.self)),
              GraphQLField("feelsLike", type: .scalar(Double.self)),
              GraphQLField("min", type: .scalar(Double.self)),
              GraphQLField("max", type: .scalar(Double.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(actual: Double? = nil, feelsLike: Double? = nil, min: Double? = nil, max: Double? = nil) {
            self.init(unsafeResultMap: ["__typename": "Temperature", "actual": actual, "feelsLike": feelsLike, "min": min, "max": max])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var actual: Double? {
            get {
              return resultMap["actual"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "actual")
            }
          }

          public var feelsLike: Double? {
            get {
              return resultMap["feelsLike"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "feelsLike")
            }
          }

          public var min: Double? {
            get {
              return resultMap["min"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "min")
            }
          }

          public var max: Double? {
            get {
              return resultMap["max"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "max")
            }
          }
        }

        public struct Wind: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Wind"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("speed", type: .scalar(Double.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(speed: Double? = nil) {
            self.init(unsafeResultMap: ["__typename": "Wind", "speed": speed])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var speed: Double? {
            get {
              return resultMap["speed"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "speed")
            }
          }
        }

        public struct Cloud: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Clouds"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("humidity", type: .scalar(Int.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(humidity: Int? = nil) {
            self.init(unsafeResultMap: ["__typename": "Clouds", "humidity": humidity])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var humidity: Int? {
            get {
              return resultMap["humidity"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "humidity")
            }
          }
        }
      }
    }
  }
}

public final class GetCityByNameQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetCityByName($cityName: String!, $country: String!) {
      getCityByName(name: $cityName, country: $country) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "GetCityByName"

  public var cityName: String
  public var country: String

  public init(cityName: String, country: String) {
    self.cityName = cityName
    self.country = country
  }

  public var variables: GraphQLMap? {
    return ["cityName": cityName, "country": country]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getCityByName", arguments: ["name": GraphQLVariable("cityName"), "country": GraphQLVariable("country")], type: .object(GetCityByName.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getCityByName: GetCityByName? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "getCityByName": getCityByName.flatMap { (value: GetCityByName) -> ResultMap in value.resultMap }])
    }

    public var getCityByName: GetCityByName? {
      get {
        return (resultMap["getCityByName"] as? ResultMap).flatMap { GetCityByName(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "getCityByName")
      }
    }

    public struct GetCityByName: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["City"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil) {
        self.init(unsafeResultMap: ["__typename": "City", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}
