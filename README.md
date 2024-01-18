#Chunk Miner
A Minecraft turtle for Minecraft ComputerCraft Minecraft mod to do mine for me... in Minecraft<br />
Coded in Lua because that's the language CC uses. ¯\_(ツ)_/¯
<br />
<br />
###Directions:<br />
The turtle's position in respect to the chunk will determine its orientation.<br />
For the following corners:<br />
<br />
NW, turtle faces WEST<br />
NE, turtle faces SOUTH<br />
SW, turtle faces NORTH<br />
SE, turtle faces EAST<br />
<br />
*Start by simply placing Timothee in the "bottom left" corner of the chunk (relative to the<br />
player), facing forward.<br />
<br />
<br />
###Process:<br />
Starting on the corner its placed, it digs out the block below it before digging out blocks below <br />
it in a straight line ahead of it; digging out a "lane". Once it reaches the opposite edge of the <br />
chunk, it goes to the next lane to the right, digging it out. Timothee continues this in a snake-<br />
like pattern until it has dug out a layer. It then goes down a block and continues to dig (again)<br />
in a snake-like pattern going the other direction. Continuing this cycle until it has reached <br />
bedrock, filled its inventory, or run low on fuel. <br />
<br />
Once Timothee runs low on fuel, it **SHOULD** return to the docking station to refuel and deposit<br />
the items it's mined. Lil' Tim automatically fuels up using coal / other burnable items it mines, <br />
which isn't enough to keep it fueled all the way to bedrock, so keep the fuel input stocked. <br />
