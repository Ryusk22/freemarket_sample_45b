$(document).ready(function(){

  var listsearch = $("#item-list")
  function appendItemSelect() {
    var html =
        `<li class='sell-upload__item'>
          <figure class='sell-upload__figure'>
            <img alt="アイコン" id="item-img" src="https://placehold.jp/150x150.png" />
          </figure>
          <div class='sell-upload-btn'>
            <a class="sell-upload__edit" href="#">編集</a>
            <a class="sell-upload__delete" href="#">削除</a>
          </div>
        </li>`
    listsearch.append(html);
  }

  $('#file-upload').on('change', function(e){
    //ファイルオブジェクトを取得する
    var file = e.target.files[0];
    var reader = new FileReader();

    //画像でない場合は処理終了
    if(file.type.indexOf("image") < 0){
      alert("画像ファイルを指定してください。");
      return false;
    }

    //アップロードした画像を設定する
    reader.onload = (function(file){
      return function(e){
        $('.sell-upload__dropbox').removeClass('have-item-0');
        $('.sell-upload__dropbox').addClass('have-item-1');
        appendItemSelect()
        $("#item-img").attr("src", e.target.result);
        $("#item-img").attr("title", file.name);
      };
    })(file);
    reader.readAsDataURL(file);

  });

// カテゴリーの表示切り替え
    // 子カテゴリーのselectを追加するHTML
    var category_search = $("#category");

    function appendchildselect() {
      var html =
          `<div class="select-wrap" id="child-wrap">
            <select class="select-default" id="child-category" name="product[category_id]">
                <option value>---</option>
            </select>
            <i class="fas fa-angle-down select-icon"></i>
          </div>`
      category_search.append(html)
    }

    // 孫カテゴリーのselectを追加するHTML
    function appendgrandchildselect() {
      var html =
          `<div class="select-wrap" id="grandchild-wrap">
            <select class="select-default" id="grandchild-category" name="product[category_id]">
                <option value>---</option>
            </select>
            <i class="fas fa-angle-down select-icon"></i>
          </div>`
      category_search.append(html)
    }

  // 子カテゴリーのoptionを追加するHTML
  function appendchild(child) {
    $("#child-category").append(
      $("<option>")
        .val($(child).attr('id'))
        .text($(child).attr('name'))
    )
  }

  // 孫カテゴリーのoptionを追加するHTML
  function appendgrandchild(grandchild) {
    $("#grandchild-category").append(
      $("<option>")
        .val($(grandchild).attr('id'))
        .text($(grandchild).attr('name'))
    )
  }

  var postage_search = $('#postage_form')
  function appendShipping_method() {
    var html =
        `<div class='form-group' id='shipping_form'>
          <label class="sell-content__label" for="product_shipping_method">配送の方法
            <span class='form-require'>必須</span>
          </label>
          <div class='select-wrap'>
            <select class="select-default" id="shipping-select" name="product[shipping_method_id]">
              <option value="">---</option>
            </select>
            <i class='fas fa-angle-down select-icon'></i>
          </div>
        </div>`
    postage_search.append(html);
  }

  // 配送方法のoptionを追加するHTML
  function appendMethod(data) {
    $("#shipping-select").append(
      $("<option>")
        .val($(data).attr('id'))
        .text($(data).attr('name'))
    )
  }

// 親カテゴリーをクリック
  $('#parent-category').change(function(e) {
    e.preventDefault();
    var parent = $(this).val();
    $("#child-wrap").remove()
    $("#grandchild-wrap").remove()
    $.ajax({ //ajax通信で以下のことを行います
      url: '/products/category', //urlを指定
      type: 'GET', //メソッドを指定
      data: ('parent=' + parent), //コントローラーに渡すデータを'keyword=input(入力された文字のことですね)'にするように指定
      dataType: 'json' //データ形式を指定
    })

    // doneメソッドでappendする
    .done(function(child) {
      appendchildselect()
      child.forEach(function(child) {
        appendchild(child)
      })
    })
  });

// 子カテゴリーをクリック
  $(document).on('change', '#child-category', function() {
    var child = $(this).val();
    $("#grandchild-wrap").remove()
    $.ajax({ //ajax通信で以下のことを行います
      url: '/products/category', //urlを指定
      type: 'GET', //メソッドを指定
      data: ('child=' + child), //コントローラーに渡すデータを'keyword=input(入力された文字のことですね)'にするように指定
      dataType: 'json' //データ形式を指定
    })

    // doneメソッドでappendする
    .done(function(grandchild) {
      appendgrandchildselect()
      grandchild.forEach(function(grandchild) {
        appendgrandchild(grandchild)
      })
    })
  });

// 配送料をクリック
  $('#postage').change(function(e){
    e.preventDefault();
    var postage = $('#postage option:selected').text();
    $("#shipping_form").remove()
    $.ajax({ //ajax通信で以下のことを行います
      url: '/products/postage', //urlを指定
      type: 'GET', //メソッドを指定
      data: ('postage=' + postage), //コントローラーに渡すデータを'keyword=input(入力された文字のことですね)'にするように指定
      dataType: 'json' //データ形式を指定
    })
    // doneメソッドでappendする
    .done(function(data) {
      appendShipping_method()
      data.forEach(function(data) {
        appendMethod(data)
      })
    })
  });

// FIXME: 入力値の計算処理後、正しくビューに表示されないため、修正する
  // $('#calc-price').keyup(function(e){
  //   e.preventDefault();
  //   var price = $(this).val();
  //   var count = $(this).val().length;
  //   if (count >= 3) {
  //   console.log(price);
  //   var fee = price * 0.1;
  //   console.log(fee);
  //   var revenue = (price - fee);
  //   console.log(revenue);
  //   var aa = $('#fee').text().replace(/-/g, fee);
  //   $('#fee').text(aa);
  //   var bb = $('#revenue').text().replace(/-/g, revenue);
  //   $('#revenue').text(bb);
  //   }
  // });

});
