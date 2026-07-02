using System;
using System.IO;

public static class PathService
{

    // Working root preference:
    //  1) <repo>\Data (if repo root detected and writable)
    //  2) %LOCALAPPDATA%\TrackerMigration\MigrationRunner
    //  3) baseDir (bin) if writable
    public static string ResolveWritableRoot(string baseDir)
    {
        // Walk up from baseDir to find MigrationRunner.csproj
        var dir = new DirectoryInfo(baseDir);
        for (int up = 0; up < 8 && dir != null; up++, dir = dir.Parent)
        {
            var csproj = Path.Combine(dir.FullName, "MigrationRunner.csproj");
            if (File.Exists(csproj))
            {
                if (EnsureWritable(Path.Combine(dir.FullName, "Metadata")))
                    return dir.FullName;
            }
        }
        return null;
    }

    public static string FindRepoRoot(string baseDir)
    {
        var dir = new DirectoryInfo(baseDir);
        for (int up = 0; up < 8 && dir != null; up++, dir = dir.Parent)
        {
            var git = Path.Combine(dir.FullName, ".git");
            if (Directory.Exists(git)) return dir.FullName;
        }
        return null;
    }

    public static bool EnsureWritable(string folder)
    {
        try
        {
            Directory.CreateDirectory(folder);
            var probe = Path.Combine(folder, ".write.test");
            File.WriteAllText(probe, "ok");
            File.Delete(probe);
            return true;
        }
        catch
        {
            return false;
        }
    }
}
