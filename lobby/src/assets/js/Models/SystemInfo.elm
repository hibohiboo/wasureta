module Models.SystemInfo exposing (..)


type alias SystemNames =
    { system : String
    , name : String
    }


type alias SystemInfoResult =
    { ok : Bool
    , systemInfo : SystemInfo
    }


type alias SystemInfo =
    { name : String
    , gameType : String
    , prefixs : List String
    , info : String
    }
