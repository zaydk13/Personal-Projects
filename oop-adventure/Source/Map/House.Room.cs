namespace OOPAdventure;

public partial class House
{

    private int CalculateRoomIndex (int col, int row)
    {
        return Math.Clamp(col, -1, Width) + Math.Clamp(row, -1, Height)*Width;
    }
 
    public void CreateRooms (int width, int height)
    {
        Width = Math.Clamp(width, 2, 10);
        Height = Math.Clamp(height, 2, 10);

        var total = Width * Height;

        Rooms = new Room[total];

        for (int i = 0; i < total; i++)
        {
            var tempRoom = new Room();

            var col = i % Width;
            var row = i / Width;

            tempRoom.Name = String.Format(Text.Language.DefaultRoomName, i, col, row);

            if (col < Width - 1)
            {
                tempRoom.Neighbors[Directions.East] = CalculateRoomIndex(col + 1, row);
            }

            if (col > 0)
            {
                tempRoom.Neighbors[Directions.West] = CalculateRoomIndex(col - 1, row);
            }

            if (row < Height - 1)
            {
                tempRoom.Neighbors[Directions.North] = CalculateRoomIndex(col, row + 1);
            }

            if (row > 0)
            {
                tempRoom.Neighbors[Directions.South] = CalculateRoomIndex(col, row - 1);
            }
        }
    }

}