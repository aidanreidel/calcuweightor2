import Browser
import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)

main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL

type alias Model = 
  { workWeight : String
  }

init : Model
init = 
  { workWeight = "45"
  }


-- UPDATE

type Msg 
  = Reset
  | Input String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset -> 
      init

    Input weight ->
      { model | workWeight = weight }


-- VIEW

view : Model -> Html Msg
view model = 
    div []
    [ input  [ value model.workWeight, onInput Input] []
    , button [ onClick Reset ] [ text "GG"]
    , viewValidation model
    ]

viewValidation : Model -> Html msg
viewValidation model = 
  if String.toInt( model.workWeight ) == Nothing then
    div [style "color" "red" ] [ text "Work weight must be a number"]
  else 
    div [] 
    [ div [] [ text "Warmup 1:\t", text model.workWeight  ]
    , div [] [ text "Warmup 2:\t", text model.workWeight  ]
    , div [] [ text "Warmup 3:\t", text model.workWeight  ]
    , div [] [ text "Warmup 4:\t", text model.workWeight  ]
    , div [] [ text "Warmup 5:\t", text model.workWeight  ]
    ]