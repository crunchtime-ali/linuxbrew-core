class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.5.1/modules-4.5.1.tar.bz2"
  sha256 "8d9829905f79d379c2cf753c7fe6f7be1188853e859f81b44f5116337e8f49d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "0eff45eac8ca106c0682606a4e20e134dbdf0c76ff9273984a88fc48744a8190" => :catalina
    sha256 "45dcef5e8a7e67b96b25cae336343eee677a699afff66ea4039742d1d6599d74" => :mojave
    sha256 "06b3c839f16bda9ebdac25ea1519533994fdb84dd89dfe6de8f56fe685508765" => :high_sierra
    sha256 "28e61cfd912321fa72ef7c6aeb2d739263c062d6f3c29b6972f7983b80a54c37" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "tcl-tk"
    depends_on "less"
  end

  def install
    tcl = OS.mac? ? "#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework" : Formula["tcl-tk"].opt_lib
    with_tclsh = OS.mac? ? "" : "--with-tclsh=#{Formula["tcl-tk"].opt_bin}/tclsh"
    with_pager = OS.mac? ? "" : "--with-pager=#{Formula["less"].opt_bin}/less"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{tcl}
      #{with_tclsh}
      #{with_pager}
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To activate modules, add the following at the end of your .zshrc:
        source #{opt_prefix}/init/zsh
      You will also need to reload your .zshrc:
        source ~/.zshrc
    EOS
  end

  test do
    assert_match "restore", shell_output("#{bin}/envml --help")
    output = if OS.mac?
      shell_output("zsh -c 'source #{prefix}/init/zsh; module' 2>&1")
    else
      shell_output("sh -c '. #{prefix}/init/sh; module' 2>&1")
    end
    assert_match version.to_s, output
  end
end
