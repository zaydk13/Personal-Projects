using OOPAdventure;

public class English : Language
{
    public English()
    {
        Welcome = "Hi, welcome {0} to your adventure";
        ChooseYourName = "What is your name?";
        DefaultName = "No name";

        DefaultRoomName = "Room {0} ({1}, {2})";
        DefaultRoomDescription = "You are in a room with doors to the {0}.";

        ActionError = "Impossible.";
        Go = "Go";
        GoError = "You can't go that way :(";

        WhatToDo = "What do you want to do?";
        Quit = "quit";
    }
}