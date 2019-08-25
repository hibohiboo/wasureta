module Utils.Time exposing (toDateFromMS)

-- https://github.com/ababup1192/elm-firebase-chat/blob/75b3bfa945a86f54fa0c926eb087d051b7a79a8e/src/Main.elm
-- https://qiita.com/ababup1192/items/803bd2e66461c70bf7e7

import Time exposing (Month(..), Posix, Weekday(..), Zone)


toDateFromMS : Int -> String
toDateFromMS ms =
    toDate Time.utc (Time.millisToPosix ms)


toDate : Zone -> Posix -> String
toDate zone time =
    let
        padZero2 =
            String.padLeft 2 '0'

        month =
            Time.toMonth zone time |> toMonthNumber

        day =
            Time.toDay zone time |> String.fromInt

        year =
            Time.toYear zone time |> String.fromInt

        hour =
            Time.toHour zone time |> String.fromInt |> padZero2

        minutes =
            Time.toMinute zone time |> String.fromInt |> padZero2

        week =
            Time.toWeekday zone time |> toJapaneseWeekday
    in
    year ++ "年" ++ month ++ "月" ++ day ++ "日 " ++ hour ++ ":" ++ minutes ++ " " ++ week ++ "曜日"


toMonthNumber : Time.Month -> String
toMonthNumber month =
    case month of
        Jan ->
            "1"

        Feb ->
            "2"

        Mar ->
            "3"

        Apr ->
            "4"

        May ->
            "5"

        Jun ->
            "6"

        Jul ->
            "7"

        Aug ->
            "8"

        Sep ->
            "9"

        Oct ->
            "10"

        Nov ->
            "11"

        Dec ->
            "12"


toJapaneseWeekday : Weekday -> String
toJapaneseWeekday weekday =
    case weekday of
        Mon ->
            "月"

        Tue ->
            "火"

        Wed ->
            "水"

        Thu ->
            "木"

        Fri ->
            "金"

        Sat ->
            "土"

        Sun ->
            "日"
