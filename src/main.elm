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
  [ table [] 
{--
      [ tr []
        [ td [] []
        , td [] [ text "Weight" ]  
        , td [] [ text "Plates" ]
        ]
      , 
--}
      [ tableRow "Warm up 1:" ( warmUpWeight weight 1 )
      , tableRow "Warm up 2:" ( warmUpWeight weight 2 )
      , tableRow "Warm up 3:" ( warmUpWeight weight 3 )
      , tableRow "Work sets:" weight 
      ]
  ]

tableRow : String -> Float -> Html msg
tableRow s w = 
  tr []        
        [ td [] [ text s ]
        , td [] [ text ( String.fromFloat w )] 
        , td [] [ text ( plates w regularPlates )]
        ]

warmUpWeight : Float -> Float -> Float
warmUpWeight x y =
  round5( y * ( ( x - 45 ) / 4 ) + 45 )

round5 : Float -> Float
round5 x = 
  toFloat( round( x / 5 ) * 5 )

plates : Float -> List Float -> String
plates x ps =
  plateStack ( ( x - 45 ) / 2 ) ps

{- Not allowed to pattern match on floats so we will use an if -}
plateStack : Float -> List Float -> String 
plateStack x ps =
  case ps of 
    [] -> ""
    a::ys -> 
      if x - a > 0 then 
        String.fromFloat(a) ++ ", " ++ (plateStack (x-a) ps)
      else if x - a == 0 then
        String.fromFloat(a)
      else 
        plateStack x ys
              
regularPlates : List Float
regularPlates = [45,35,25,10,5,2.5,1.25]

oylmpicPlates : List Float
oylmpicPlates = 55::regularPlates
