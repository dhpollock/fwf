
/**
 * Call this one time in your main() function to initialize all popover menus
 */
part of fwf;

class Button{
  
  void initButton(var input) {
    var buttons = querySelectorAll(".button");
    for (Element button in buttons) {
      var items = querySelectorAll("#${button.id} button");
      for (Element item in items) {
        item.onClick.listen((event) {
          //hidePopover(popover.id);
          buttonAction(input);
        });
      }
    }
  }
  
  
  /**
   * Call this function to make a popover menu appear on the screen.
   * You can provide an optional x,y coordinate for the menu.
   */
  
  void showButton(String id, [ num x, num y ]) {
    DivElement button = querySelector("#$id");
    if (button != null) {

      button.style.visibility = "visible";
      button.style.opacity = "1.0";
    }
  }
  
  
  
  /**
   * You'll need to implement this function to do stuff when the user selects
   * an item in a popover menu
   */
  void buttonAction(var input) {
    //window.alert("$popover, $action");
    return input();
  }
}