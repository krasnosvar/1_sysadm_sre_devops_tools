# submenu
submenu () {
  local PS3='Please enter sub option: '
  local options=("Sub menu item 1" "Sub menu item 2" "Sub menu quit")
  local opt

#######from other script


  unset option menu ERROR      # prevent inheriting values from the shell
  declare -a menu              # create an array called $menu
  menu[0]=""  
#################

  select opt in "${options[@]}"
  do
      case $opt in
          "Sub menu item 1")
              menu() {
                echo "Please select an option by typing in the corresponding number"
                echo ""
                for (( i=1; i<${#menu[@]}; i++ )); do
                  echo "$i) ${menu[$i]}"
                done
                echo "" 
              }

              # initial menu
              menu
              read option

              # loop until given a number with an associated menu item
              while ! [ "$option" -gt 0 ] 2>/dev/null || [ -z "${menu[$option]}" ]; do
                echo "No such option '$option'" >&2  # output this to standard error
                menu
                read option
              done
              echo "You said '$option' which is '${menu[$option]}'"
              ;;
          "Sub menu item 2")
              echo "you chose sub item 2"
              ;;
          "Sub menu quit")
              return
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}

# main menu
PS3='Please enter main option: '
options=("Main menu item 1" "Submenu" "Main menu quit")
select opt in "${options[@]}"
do
    case $opt in
        "Main menu item 1")
            echo "you chose main item 1"
            ;;
        "Submenu")
            submenu
            ;;
        "Main menu quit")
            exit
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
