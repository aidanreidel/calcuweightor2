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
  = Input String

update : Msg -> Model -> Model
update msg model =
  case msg of

    Input weight ->
      { model | workWeight = weight }


-- VIEW

view : Model -> Html Msg
view model = 
    div []
    [ div [class "banner"] [h1 [] [text "Calcuweightor2"] ] 
    , div [class "main" ] [input  [ value model.workWeight, onInput Input] []
    , viewValidation model ]
    ]
    

viewValidation : Model -> Html msg
viewValidation model =
  case String.toFloat( model.workWeight ) of
    Nothing -> 
      div [style "color" "red" ] [ text "Work weight must be a number"]
    
    Just weight ->
      if weight < 45 then 
        div [style "color" "red" ] [ text "Work weight must be at least 45"]

      else if not (twoPointFiveDivides model.workWeight) then
        div [style "color" "red" ] [ text "Work weight must be a multiple of 2.5"]

      else 
        calcuweightWarmups weight

-- TODO: Maybe refactor this 
twoPointFiveDivides : String -> Bool
twoPointFiveDivides s = 
  if String.contains "." s then 
    (String.endsWith ".5" s) && (endsWith2or7 s) 
  else 
    ( String.right 1 s ) == "0" || (String.right 1 s ) == "5"

endsWith2or7 : String -> Bool
endsWith2or7 = 
  (\n -> n == "2" || n == "7" ) << String.right 1 << String.dropRight 2

calcuweightWarmups : Float -> Html msg
calcuweightWarmups weight = 
  div [ class "container" ] 
    [ div [ class "warmup" ] [ text "Warm Up 3:\t", text ( String.fromInt ( warmUpWeight weight 1 )) ]
    , div [ class "warmup" ] [ text "Warm Up 4:\t", text ( String.fromInt ( warmUpWeight weight 2 )) ]
    , div [ class "warmup" ] [ text "Warm Up 5:\t", text ( String.fromInt ( warmUpWeight weight 3 )) ]
    , div [ class "workset" ] [ text "Work Sets:\t", text ( String.fromFloat weight ) ] ]

warmUpWeight : Float -> Float -> Int
warmUpWeight x y =
  round5(y * ( ( x - 45 ) / 4 ) + 45 )


round5 : Float -> Int
round5 x = 
  round( x / 5 ) * 5

