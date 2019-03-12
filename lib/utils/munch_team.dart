class MunchTeam {
  static Set<String> _all = Set<String>.of([
    "oNOfWjsL49giM0", // YZ
    "sGtVZuFJwYhf5O", // FX
    "GoNd1yY0uVcA8p", // EL
    "CM8wAOSdenMD8d", // JD
    "0aMrslcgMyW3xb", // ST
  ]);

  static bool isTeam(String userId) {
    return _all.contains(userId.substring(0, 14));
  }
}
