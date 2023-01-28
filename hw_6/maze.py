from PIL import Image

SCALE = 1
#等比例缩放

def get_char(pixel, blank_char='0', fill_char='1'):
   if pixel == 0:
       return blank_char
   else:
       return fill_char

def get_int(pixel, blank_char=0, fill_char=1):
   if pixel == 0:
       return blank_char
   else:
       return fill_char


im = Image.open(r"maze.jpg")
size = im.size
#获取图片的像素
#size[0]*size[1] 横宽像素
width, height = int(size[0] * SCALE), int(size[1] * SCALE)
im = im.resize((width, height))#修改图片尺寸
im = im.convert('1')#获得二值图像

rawmaze = []
for i in range(height):
    rawmaze.append([])
    for j in range(width):
        rawmaze[i].append(get_int(im.getpixel((j, i))))#getpixel是获取图像中某一点像素的RGB颜色值

start_x,start_y = 49,0
for j in range (width):
    if rawmaze[start_x][j]==1:
        start_y = j
        break

maze1 = []
for i in range(49):
    maze1.append([])
    x = start_x + 8*i
    for j in range(65):
        y = start_y + 8*j
        maze1[i].append(rawmaze[x][y])
maze1[48][63]=1
maze1[44][63]=0
#maze1[39][60]=1

#print(maze1[31][55],maze1[30][55],maze1[32][55],maze1[31][56])
# txt = ""
# for i in range(height):
#     for j in range(width):
#         txt += get_char(im.getpixel((j, i)))#getpixel是获取图像中某一点像素的RGB颜色值
#     txt += '\n'
# #print(txt)
# f = open(r'maze.txt', 'w')

# print(txt, file=f)

# f.close()

