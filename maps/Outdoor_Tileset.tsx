<?xml version="1.0" encoding="UTF-8"?>
<tileset name="Outdoor_Tileset" tilewidth="16" tileheight="16" tilecount="16" columns="4">
 <image source="../assets/Outdoor_Tileset.png" width="64" height="64"/>
 <terraintypes>
  <terrain name="Solid Ground" tile="-1"/>
  <terrain name="Passable Ground" tile="-1"/>
  <terrain name="Air" tile="-1"/>
 </terraintypes>
 <tile id="0" terrain="2,2,2,1">
  <properties>
   <property name="collidable" type="bool" value="true"/>
   <property name="one_way_platform" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="1" terrain="2,2,1,1">
  <properties>
   <property name="collidable" type="bool" value="true"/>
   <property name="one_way_platform" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="2" terrain="2,2,1,2">
  <properties>
   <property name="collidable" type="bool" value="true"/>
   <property name="one_way_platform" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="3" terrain="2,2,2,2"/>
 <tile id="4" terrain="2,1,2,1">
  <properties>
   <property name="collidable" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="5" terrain="1,1,1,1">
  <properties>
   <property name="collidable" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="6" terrain="1,2,1,2">
  <properties>
   <property name="collidable" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="8" terrain="2,2,2,0">
  <properties>
   <property name="collidable" type="bool" value="true"/>
   <property name="solid" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="9" terrain="2,2,0,0">
  <properties>
   <property name="collidable" type="bool" value="true"/>
   <property name="solid" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="10" terrain="2,2,0,2">
  <properties>
   <property name="collidable" type="bool" value="true"/>
   <property name="solid" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="12" terrain="2,0,2,0">
  <properties>
   <property name="collidable" type="bool" value="true"/>
   <property name="solid" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="13" terrain="0,0,0,0">
  <properties>
   <property name="collidable" type="bool" value="true"/>
   <property name="solid" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="14" terrain="0,2,0,2">
  <properties>
   <property name="collidable" type="bool" value="true"/>
   <property name="solid" type="bool" value="true"/>
  </properties>
 </tile>
</tileset>
