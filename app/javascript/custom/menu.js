// メニュー操作

// トグルリスナーを追加してクリックをリッスンする
// document.addEventListener("turbo:load", function() {
//     let hamburger = document.querySelector("#hamburger");
//   if (hamburger){
//     hamburger.addEventListener("click", function(event) {
//       event.preventDefault();
//       let menu = document.querySelector("#navbar-menu");
//       menu.classList.toggle("collapse");
//     });
//   }
//     console.log("Turbo load event fired"); // イベントが発火したことを確認
//     let account = document.querySelector("#account");
//     if (account) {
//         console.log("Account element found"); // 要素が見つかったことを確認
//         account.addEventListener("click", function(event) {
//             event.preventDefault();
//             let menu = document.querySelector("#dropdown-menu");
//             if (menu) {
//                 console.log("Dropdown menu found"); // メニューが見つかったことを確認
//                 menu.classList.toggle("active");
//                 console.log("Menu classList:", menu.classList); // メニューのクラスリストを確認
//             } else {
//                 console.error("Dropdown menu not found");
//             }
//         });
//     } else {
//         console.error("Account element not found");
//     }
// });

// トグルリスナーを追加する
function addToggleListener(selected_id, menu_id, toggle_class) {
    let selected_element = document.querySelector(`#${selected_id}`);
    selected_element.addEventListener("click", function(event) {
      event.preventDefault();
      let menu = document.querySelector(`#${menu_id}`);
      menu.classList.toggle(toggle_class);
    });
  }
  
  // クリックをリッスンするトグルリスナーを追加する
  document.addEventListener("turbo:load", function() {
    addToggleListener("hamburger", "navbar-menu",   "collapse");
    addToggleListener("account",   "dropdown-menu", "active");
  });