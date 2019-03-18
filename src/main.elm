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
  case String.toInt( model.workWeight ) of
    Nothing -> 
      div [style "color" "red" ] [ text "Work weight must be a number"]
    
    Just weight ->
      if weight < 45 then 
        div [style "color" "red" ] [ text "Work weight must be at least 45"]
      else 
        calcuweightWarmups weight

calcuweightWarmups : Int -> Html msg
calcuweightWarmups weight = 
  div [ class "container" ] 
    [ div [ class "warmup" ] [ text "Warm Up 3:\t", text ( String.fromInt ( warmUpWeight weight 1 )) ]
    , div [ class "warmup" ] [ text "Warm Up 4:\t", text ( String.fromInt ( warmUpWeight weight 2 )) ]
    , div [ class "warmup" ] [ text "Warm Up 5:\t", text ( String.fromInt ( warmUpWeight weight 3 )) ]
    , div [ class "workset" ] [ text "Work Sets:\t", text ( String.fromInt weight ) ] ]

warmUpWeight : Int -> Int -> Int
warmUpWeight x y =
  round5 ( y * ( ( x - 45 ) // 4 ) + 45 )

round5 : Int -> Int
round5 x = 
  if modBy 5 x < 2 then
    x - ( 5 - ( modBy 5 x ) )
  else 
    x + ( 5 - ( modBy 5 x ) )


