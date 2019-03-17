import Browser
import Html exposing (..)
import Html.Events exposing (onClick)

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

type Msg = CalcuWeight | Reset

update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset -> 
      init

    CalcuWeight ->
      { model | workWeight = model.workWeight + 5 }
    
    


-- VIEW

view : Model -> Html Msg
view model = 
    div []
    [ div [] [ text (String.fromInt model.workWeight) ]
    , button [ onClick CalcuWeight ] [ text "CalcuWeight!" ]
    , button [ onClick Reset ] [ text "GG"]
    ]