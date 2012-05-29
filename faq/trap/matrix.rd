* Matrix#det
* Matrix#determinant

  内部で割り算してるため，要素が Integer の場合は結果がおかしくなります．

        $ ruby -r matrix -e 'p Matrix[[3, 2], [4, 1]].det'
        -3

  きちんと計算させるためには，要素を Float にして

        $ ruby -r matrix -e 'p Matrix[[3.0, 2.0], [4.0, 1.0]].det'
        -5.0

  とするか，mathn を require して

        $ ruby -r mathn -r matrix -e 'p Matrix[[3, 2], [4, 1]].det'
        -5

  こうしましょう．
