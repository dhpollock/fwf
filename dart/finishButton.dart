part of fwf;


class finishButton{
  
  
  void initfinishButton(var input) {
    var finishButtons = querySelectorAll(".finishButton");
    for (Element finishButton in finishButtons) {
      var items = querySelectorAll("#${finishButton.id} li");
      for (Element item in items) {
        item.onClick.listen((event) {
          hidefinishButton(finishButton.id);
          finishButtonAction(input);
        });
      }

    }
  }
  
  
  /**
   * Call this function to make a popover menu appear on the screen.
   * You can provide an optional x,y coordinate for the menu.
   */
  void showfinishButton(String id, [ num x, num y ]) {
    DivElement finishButton = querySelector("#$id");
    if (finishButton != null) {
      if (x != null && y != null) {
        finishButton.style.left = "${x.toInt() + 50}px";
        finishButton.style.top = "${y.toInt() - 55}px";
      }
      finishButton.style.visibility = "visible";
      finishButton.style.opacity = "1.0";
    }
  }
  
  
  /**
   * Call this function to hide a popover menu
   */
  void hidefinishButton(String id) {
    DivElement finishButton = querySelector("#$id");
    if (finishButton != null) {
      finishButton.style.opacity = "0.0";
      new Timer(const Duration(milliseconds : 300), () {
        finishButton.style.visibility = "hidden";
      });
    }
  }
  
  
  /**
   * You'll need to implement this function to do stuff when the user selects
   * an item in a popover menu
   */
  var finishclick = 0;
  
  void finishButtonAction(input) {
    //when both players click button game transitions to next phase
    finishclick++;
    if (finishclick%2 == 0){
      return input();
    }
  }
  
}
