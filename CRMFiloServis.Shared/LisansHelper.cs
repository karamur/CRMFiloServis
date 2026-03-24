using System;
using System.Management;
using System.Security.Cryptography;
using System.Text;

namespace CRMFiloServis.Shared;

public static class LisansHelper
{
    /// <summary>
    /// Bilgisayarýn benzersiz makine kodunu üretir
    /// (CPU ID + Ana Kart Seri No + Disk Seri No)
    /// </summary>
    public static string GetMachineCode()
    {
        try
        {
            var cpuId = GetCpuId();
            var motherboardSerial = GetMotherboardSerial();
            var diskSerial = GetDiskSerial();

            var combined = $"{cpuId}-{motherboardSerial}-{diskSerial}";

            // Hash'le daha kýsa ve standart hale getir
            using var sha256 = SHA256.Create();
            var hash = sha256.ComputeHash(Encoding.UTF8.GetBytes(combined));
            return Convert.ToBase64String(hash).Substring(0, 32).Replace("/", "").Replace("+", "");
        }
        catch
        {
            // Hata durumunda fallback
            return Environment.MachineName.GetHashCode().ToString("X8");
        }
    }

    private static string GetCpuId()
    {
        try
        {
            var searcher = new ManagementObjectSearcher("SELECT ProcessorId FROM Win32_Processor");
            foreach (ManagementObject obj in searcher.Get())
            {
                return obj["ProcessorId"]?.ToString() ?? "UNKNOWN";
            }
        }
        catch { }
        return "CPU-UNKNOWN";
    }

    private static string GetMotherboardSerial()
    {
        try
        {
            var searcher = new ManagementObjectSearcher("SELECT SerialNumber FROM Win32_BaseBoard");
            foreach (ManagementObject obj in searcher.Get())
            {
                return obj["SerialNumber"]?.ToString() ?? "UNKNOWN";
            }
        }
        catch { }
        return "MB-UNKNOWN";
    }

    private static string GetDiskSerial()
    {
        try
        {
            var searcher = new ManagementObjectSearcher("SELECT SerialNumber FROM Win32_PhysicalMedia");
            foreach (ManagementObject obj in searcher.Get())
            {
                var serial = obj["SerialNumber"]?.ToString()?.Trim();
                if (!string.IsNullOrEmpty(serial))
                    return serial;
            }
        }
        catch { }
        return "DISK-UNKNOWN";
    }

    /// <summary>
    /// Makine kodunu görsel formatta göster
    /// </summary>
    public static string FormatMachineCode(string machineCode)
    {
        if (string.IsNullOrEmpty(machineCode) || machineCode.Length < 16)
            return machineCode;

        // XXXX-XXXX-XXXX-XXXX formatýnda göster
        var formatted = "";
        for (int i = 0; i < Math.Min(machineCode.Length, 16); i++)
        {
            if (i > 0 && i % 4 == 0)
                formatted += "-";
            formatted += machineCode[i];
        }
        return formatted;
    }
}
