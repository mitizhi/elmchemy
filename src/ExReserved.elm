module ExReserved exposing (..)


ops : List ( Int, Char )
ops =
    [ '+', '-', '/', '*', '=', '.', '$', '<', '>', ':', '&', '|', '^', '?', '%', '#', '@', '~', '!' ] |> List.indexedMap (,)


maybeReplaceStd : String -> String
maybeReplaceStd s =
    if isStdModule s then
        "X" ++ s
    else if s == "Native" then
        Debug.crash
            ("Compile found out you're using Native modules in the codebase."
                ++ "Elmchemy doesn't support Elm Native Modules since they're JavaScript"
            )
    else
        s


isStdModule : String -> Bool
isStdModule a =
    List.member a
        [ "Basics"
        , "List"
        , "String"
        , "Maybe"
        , "Char"
        , "Result"
        , "Tuple"
        ]


reservedWords : List String
reservedWords =
    [ "fn", "do", "end" ]


replaceOp : String -> String
replaceOp op =
    String.toList op
        |> List.map replaceOp_
        |> String.join ""
        |> flip (++) "__"


replaceOp_ : Char -> String
replaceOp_ op =
    case
        List.filter (\( i, o ) -> op == o) ops
    of
        ( index, _ ) :: _ ->
            "op" ++ toString index

        _ ->
            Debug.crash "Illegal op"


maybeReplaceReserved : String -> String
maybeReplaceReserved a =
    if List.member a reservedWords then
        a ++ "__"
    else
        a
