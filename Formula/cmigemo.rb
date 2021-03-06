class Cmigemo < Formula
  desc "Migemo is a tool that supports Japanese incremental search with Romaji"
  homepage "http://www.kaoriya.net/software/cmigemo"
  head "https://github.com/koron/cmigemo.git"

  stable do
    url "https://cmigemo.googlecode.com/files/cmigemo-default-src-20110227.zip"
    sha256 "4aa759b2e055ef3c3fbeb9e92f7f0aacc1fd1f8602fdd2f122719793ee14414c"

    # Patch per discussion at: https://github.com/Homebrew/homebrew/pull/7005
    patch :DATA
  end
  bottle do
    cellar :any
    sha256 "866dfa4f493c088c1b2eb3cff23ed04e33862f7bc5dcff0976ce5b7cb4835dd2" => :el_capitan
    sha256 "4ab378bb5f5d2462a6043d9226aade8b87974b52a7fec8a24e3814f93ac936f6" => :yosemite
    sha256 "f4b8738e34c2b8b7d8489c70a6e15e1634e9d2b0f20b2180be4dd6d43eca6c4a" => :mavericks
  end


  depends_on "nkf" => :build

  def install
    chmod 0755, "./configure"
    system "./configure", "--prefix=#{prefix}"
    system "make", "osx"
    system "make", "osx-dict"
    system "make", "-C", "dict", "utf-8" if build.stable?
    ENV.j1 # Install can fail on multi-core machines unless serialized
    system "make", "osx-install"
  end

  def caveats; <<-EOS.undent
    See also https://github.com/emacs-jp/migemo to use cmigemo with Emacs.
    You will have to save as migemo.el and put it in your load-path.
    EOS
  end
end

__END__
--- a/src/wordbuf.c	2011-08-15 02:57:05.000000000 +0900
+++ b/src/wordbuf.c	2011-08-15 02:57:17.000000000 +0900
@@ -9,6 +9,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
 #include "wordbuf.h"

 #define WORDLEN_DEF 64
