#!/bin/bash
# Manage dock themes

#========================
#   	VARIABLES		=
#========================


IMPORTFILE="Docktheme.css"


#========================
#	   	FUNCTIONS   	=
#========================


# add an import to gtk.css so it can apply stuff
function enable_theme()
{
	if ! grep -q "@import \"$IMPORTFILE\";" ~/.config/gtk-4.0/gtk.css 
	then
		echo "import line not present in gtk.css. Adding."
		echo '/* Import line for the eOS dock theme switcher. Comment for vanilla. */' >> ~/.config/gtk-4.0/gtk.css	
	    echo "@import \"$IMPORTFILE\";" >> ~/.config/gtk-4.0/gtk.css	
	fi
	#killall io.elementary.dock
}




# Remove import in gtk config
# Remove file to leave no leftover
# dock restart
function disable_theme()
{

	echo "removing import line in gtk.css."
	
	
	# Cant seem to chain directly to itself
	cat ~/.config/gtk-4.0/gtk.css \
	| grep -v  "@import \"$IMPORTFILE\";" \
	| grep -v "/* Import line for the eOS dock theme switcher." \
	> ~/.config/gtk-4.0/gtk1.css

	# Use the temporary, then delete
	cat ~/.config/gtk-4.0/gtk1.css > ~/.config/gtk-4.0/gtk.css	
	rm -f ~/.config/gtk-4.0/gtk1.css

	rm -vf ~/.config/gtk-4.0/$IMPORTFILE
	#killall io.elementary.dock
}



#========================
#   	EXECUTION   	=
#========================


if [[ -f "$*" ]]		# Its a file
then


	echo "/* CURRENT: $* */" 	> ~/.config/gtk-4.0/$IMPORTFILE
	echo "" 					>> ~/.config/gtk-4.0/$IMPORTFILE
	cat "$*"  					>> ~/.config/gtk-4.0/$IMPORTFILE
	enable_theme



else
	disable_theme


fi