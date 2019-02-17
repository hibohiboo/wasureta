module InfoToData exposing (toData)

import InfoParser exposing (parse, Info)
import Graph
import Array


toData : List Info -> Graph.Graph String ()
toData informations =
    Graph.fromNodeLabelsAndEdgePairs
        (List.map
            (\info -> info.title)
            informations
        )
        ((Array.indexedMap infoToData (Array.fromList informations))
            |> Array.toList
            |> List.concat
        )



-- infoの中のlistを(0, 1)のような形にする


infoToData : Int -> Info -> List ( Graph.NodeId, Graph.NodeId )
infoToData i info =
    List.concat [ (List.map (\v -> ( i, v )) info.list) ]
