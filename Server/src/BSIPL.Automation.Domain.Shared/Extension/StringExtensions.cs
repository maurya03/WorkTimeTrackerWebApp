namespace BSIPL.Automation.Extension
{
    public static class StringExtensions
    {
        public static bool NullOrEmpty(this string str)
        {
             if (str == null)
                return true;

            return string.IsNullOrEmpty(str.Trim());
        }
    }
}
