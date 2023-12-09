shell scripts by donnaken15
NodeQBC by zedek

patch this part of PakHandler after cloning GHSDK so it doesn't crash the game when building global.pak:
diff --git a/SDKCode/Pak/PakHandler.js b/SDKCode/Pak/PakHandler.js
index 3aedbdd..75b1ad7 100644
--- a/SDKCode/Pak/PakHandler.js
+++ b/SDKCode/Pak/PakHandler.js
@@ -1008,7 +1008,7 @@ class GHWTPakHandler
 			{
 				// PakFullFilenameQBKey
 				var pakKey = parseInt(fDat.pakFullFilenameKey, 16);
-				w.UInt32(pakKey);
+				w.UInt32(0);
 				
 				// Full filename QB key
 				var fullKey = Checksums.Make(fDat.fullName);

and create a new file in GHSDK/Config/config.ini with contents:
[SDKConfig]
DefaultMod=qb