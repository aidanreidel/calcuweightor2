import Browser
import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)

main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL

type alias Model = 
  { workWeight : Int
  , warmup1 : Int
  , warmup2 : Int
  , warmup3 : Int
  , warmup4 : Int
  , warmup5 : Int
  }

init : Model
init = 
  { workWeight = 45
  , warmup1 = 45
  , warmup2 = 45
  , warmup3 = 45
  , warmup4 = 45
  , warmup5 = 45
  }



-- UPDATE

type Msg 
  = CalcuWeight 
  | Reset
  | Input String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset -> 
      init

    CalcuWeight ->
      { model | workWeight = model.workWeight + 5 }

    Input weight ->
      { model | workWeight = String.toInt weight |> Maybe.withDefault 45 }
    


-- VIEW

view : Model -> Html Msg
view model = 
    div []
    [ div [] [ text "Warmup 1:\t", text ( String.fromInt model.warmup1 ) ]  
    , div [] [ text "Warmup 2:\t", text ( String.fromInt model.warmup2 ) ]  
    , div [] [ text "Warmup 3:\t", text ( String.fromInt model.warmup3 ) ]  
    , div [] [ text "Warmup 4:\t", text ( String.fromInt model.warmup4 ) ]  
    , div [] [ text "Warmup 5:\t", text ( String.fromInt model.warmup5 ) ]  
    , input  [ value (String.fromInt model.workWeight), onInput Input] []
    , button [ onClick CalcuWeight ] [ text "CalcuWeight!" ]
    , button [ onClick Reset ] [ text "GG"]
    ]