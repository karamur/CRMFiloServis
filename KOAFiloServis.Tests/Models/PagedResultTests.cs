using KOAFiloServis.Web.Models;

namespace KOAFiloServis.Tests.Models;

public class PagedResultTests
{
    [Fact]
    public void TotalPages_DogruHesaplanir()
    {
        var result = new PagedResult<string>
        {
            TotalCount = 100,
            PageSize = 25
        };
        Assert.Equal(4, result.TotalPages);
    }

    [Fact]
    public void TotalPages_KusurluBolme_YukarıYuvarlar()
    {
        var result = new PagedResult<string>
        {
            TotalCount = 101,
            PageSize = 25
        };
        Assert.Equal(5, result.TotalPages);
    }

    [Fact]
    public void HasPreviousPage_IlkSayfa_False()
    {
        var result = new PagedResult<string> { PageNumber = 1 };
        Assert.False(result.HasPreviousPage);
    }

    [Fact]
    public void HasPreviousPage_IkinciSayfa_True()
    {
        var result = new PagedResult<string> { PageNumber = 2 };
        Assert.True(result.HasPreviousPage);
    }

    [Fact]
    public void HasNextPage_SonSayfa_False()
    {
        var result = new PagedResult<string>
        {
            TotalCount = 50,
            PageSize = 25,
            PageNumber = 2
        };
        Assert.False(result.HasNextPage);
    }

    [Fact]
    public void HasNextPage_OrtaSayfa_True()
    {
        var result = new PagedResult<string>
        {
            TotalCount = 100,
            PageSize = 25,
            PageNumber = 2
        };
        Assert.True(result.HasNextPage);
    }

    [Fact]
    public void Empty_BosListeDoner()
    {
        var result = PagedResult<string>.Empty(10);
        Assert.Empty(result.Items);
        Assert.Equal(0, result.TotalCount);
        Assert.Equal(1, result.PageNumber);
        Assert.Equal(10, result.PageSize);
    }

    [Fact]
    public void Constructor_DegerlerDogruAtanir()
    {
        var items = new List<string> { "a", "b" };
        var result = new PagedResult<string>(items, 50, 3, 10);

        Assert.Equal(2, result.Items.Count);
        Assert.Equal(50, result.TotalCount);
        Assert.Equal(3, result.PageNumber);
        Assert.Equal(10, result.PageSize);
    }
}

public class PagingParametersTests
{
    [Fact]
    public void PageSize_MaxDegerAsamaz()
    {
        var paging = new PagingParameters { PageSize = 500 };
        Assert.Equal(100, paging.PageSize);
    }

    [Fact]
    public void PageSize_NormalDeger_Kabul()
    {
        var paging = new PagingParameters { PageSize = 50 };
        Assert.Equal(50, paging.PageSize);
    }

    [Fact]
    public void Skip_DogruHesaplanir()
    {
        var paging = new PagingParameters { PageNumber = 3, PageSize = 10 };
        Assert.Equal(20, paging.Skip);
    }

    [Fact]
    public void VarsayilanDegerler_Doğru()
    {
        var paging = new PagingParameters();
        Assert.Equal(1, paging.PageNumber);
        Assert.Equal(25, paging.PageSize);
        Assert.Equal(0, paging.Skip);
    }
}
