using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace CRMFiloServis.Web.Data.Migrations
{
    /// <inheritdoc />
    public partial class BudgetOdemeModulu : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "BudgetMasrafKalemleri",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    KalemAdi = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    Kategori = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    Renk = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    Icon = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    Aktif = table.Column<bool>(type: "boolean", nullable: false),
                    SiraNo = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BudgetMasrafKalemleri", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "BudgetOdemeler",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    OdemeTarihi = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    OdemeAy = table.Column<int>(type: "integer", nullable: false),
                    OdemeYil = table.Column<int>(type: "integer", nullable: false),
                    MasrafKalemi = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    Aciklama = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    Miktar = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: false),
                    TaksitliMi = table.Column<bool>(type: "boolean", nullable: false),
                    ToplamTaksitSayisi = table.Column<int>(type: "integer", nullable: false),
                    KacinciTaksit = table.Column<int>(type: "integer", nullable: false),
                    TaksitGrupId = table.Column<Guid>(type: "uuid", nullable: true),
                    TaksitBaslangicAy = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    TaksitBitisAy = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    Durum = table.Column<int>(type: "integer", nullable: false),
                    Notlar = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BudgetOdemeler", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BudgetMasrafKalemleri_KalemAdi",
                table: "BudgetMasrafKalemleri",
                column: "KalemAdi");

            migrationBuilder.CreateIndex(
                name: "IX_BudgetOdemeler_OdemeYil_OdemeAy_MasrafKalemi",
                table: "BudgetOdemeler",
                columns: new[] { "OdemeYil", "OdemeAy", "MasrafKalemi" });

            migrationBuilder.CreateIndex(
                name: "IX_BudgetOdemeler_TaksitGrupId",
                table: "BudgetOdemeler",
                column: "TaksitGrupId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BudgetMasrafKalemleri");

            migrationBuilder.DropTable(
                name: "BudgetOdemeler");
        }
    }
}
