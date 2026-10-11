# Clarence Online Versus

Online 2-player versus for the five Clarence mini-games (Stickers, Merciless, Crypto, Claw, Rock).

## Run locally
    npm install
    npm start
Open http://localhost:8080 in two browser tabs. Tab 1: Create room. Tab 2: enter the code, Join.
In the game press ONLINE VERSUS (bottom-left of the title screen). The host picks the mini-game.

## IMPORTANT: dialogues.xml
web/dialogues.xml is a STUB so the mini-games boot. Replace it with the original game's dialogues.xml for story mode.

## Free hosting (Render)
1. Push this folder to a GitHub repo.
2. Render -> New -> Web Service -> connect the repo.
3. Build command: npm install   Start command: npm start   Instance type: Free.
4. Deploy, then both players open the Render URL.
Free instances sleep after 15 idle minutes (~30s wake-up) and may restart anytime; just recreate the room.

## Rebuilding the SWF (source/)
1. Download JPEXS (ffdec) and export scripts: ffdec-cli -export script out/ cstd.swf
2. python3 patch.py   (applies the hooks; paths at the top of the file)
3. java -cp "ffdec/lib/*" AddScript.java cstd.swf with_mp.swf MP.as MP.as   (adds the new class)
4. ffdec-cli -importScript with_mp.swf cstd_mp.swf <patched scripts folder>

## Status
Server relay tested with fake clients. The SWF compiles but has NOT been run in Flash/Ruffle yet.

## Changelog: Rock + Crypto update
- Rock Battle (online): notes are random (seeded, so both players get the same ones). The host picks a difficulty in the
  lobby: EASY 1.5 notes/s, NORMAL 2.5, HARD 4.0 (40 s song). Fewer misses wins; tie -> more hits; still tied -> draw.
  Tweak `MP.NPS` / `MP.DURATION` at the top of source/MP.as to change speeds or length.
- Crypto Race: the course is randomized every run (solo and online; online both players share the seed).
  No row ever has a 1-lane-wide gap; every free stretch is at least 2 lanes wide.
- Solo story-mode Rock is unchanged.
