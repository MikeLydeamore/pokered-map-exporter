from PIL import Image
from PIL import ImageOps

def chop_ssanne_room(room_image, room_size = (64, 96), void_size = (96, 64)):
  rooms_across = 3
  rooms_down = 2

  rooms = []
  for r in range(rooms_down):
    for c in range(rooms_across):
      left = c * (room_size[0] + void_size[0])
      upper = r * (room_size[1] + void_size[1])
      right = left + room_size[0]
      lower = upper + room_size[1]

      room = room_image.crop((left, upper, right, lower))
      rooms.append(room)

  return rooms

def main():
  base_path = "out/maps_with_npcs/grayscale"

  room_image = Image.open(f"{base_path}/ssanne1frooms.png")

  first_rooms = chop_ssanne_room(room_image)

  first_floor_image = Image.open(f"{base_path}/ssanne1f.png")

  for i in range(1,6):
    first_floor_image.alpha_composite(first_rooms[i], (80*((6-i)), 160))

  first_floor_image.alpha_composite(first_rooms[0], (80*6+16, 160))
  
  first_floor_image.save(f"{base_path}/ssanne1f_combined.png")

  second_rooms_image = Image.open(f"{base_path}/ssanne2frooms.png")
  second_rooms = chop_ssanne_room(second_rooms_image)

  second_floor_image = Image.open(f"{base_path}/ssanne2f.png")

  for i in range(6):
    second_floor_image.alpha_composite(second_rooms[i], (72+(64+16)*(i), 160-96))

  second_floor_image.save(f"{base_path}/ssanne2f_combined.png")

  second_rooms_image = Image.open(f"{base_path}/ssanneb1frooms.png")
  b1f_rooms = chop_ssanne_room(second_rooms_image)

  b1f_floor_image = Image.open(f"{base_path}/ssanneb1f.png")
  
  width, height = b1f_floor_image.size
  new_height = height + 80
  # Get the color of the top-left pixel
  top_left_color = b1f_floor_image.getpixel((0, 0))
  new_image = Image.new("RGBA", (width, new_height), top_left_color)
  new_image.paste(b1f_floor_image, (0, 80))
  b1f_floor_image = new_image

  for i in range(5):
    b1f_floor_image.alpha_composite(b1f_rooms[i], (48+(64+16)*(i), 160-144))

  b1f_floor_image.save(f"{base_path}/ssanneb1f_combined.png")

if __name__ == "__main__":
  main()