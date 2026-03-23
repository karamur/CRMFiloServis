using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CRMFiloServis.Web.Data.Migrations
{
    /// <inheritdoc />
    public partial class BudgetOdemePaymentTracking : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "BankaKasaHareketId",
                table: "BudgetOdemeler",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "FaturaId",
                table: "BudgetOdemeler",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "FaturaIleKapatildi",
                table: "BudgetOdemeler",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "GercekOdemeTarihi",
                table: "BudgetOdemeler",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "OdemeNotu",
                table: "BudgetOdemeler",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "OdemeYapildigiHesapId",
                table: "BudgetOdemeler",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "OdenenTutar",
                table: "BudgetOdemeler",
                type: "numeric",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_BudgetOdemeler_FaturaId",
                table: "BudgetOdemeler",
                column: "FaturaId");

            migrationBuilder.CreateIndex(
                name: "IX_BudgetOdemeler_OdemeYapildigiHesapId",
                table: "BudgetOdemeler",
                column: "OdemeYapildigiHesapId");

            migrationBuilder.AddForeignKey(
                name: "FK_BudgetOdemeler_BankaHesaplari_OdemeYapildigiHesapId",
                table: "BudgetOdemeler",
                column: "OdemeYapildigiHesapId",
                principalTable: "BankaHesaplari",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_BudgetOdemeler_Faturalar_FaturaId",
                table: "BudgetOdemeler",
                column: "FaturaId",
                principalTable: "Faturalar",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_BudgetOdemeler_BankaHesaplari_OdemeYapildigiHesapId",
                table: "BudgetOdemeler");

            migrationBuilder.DropForeignKey(
                name: "FK_BudgetOdemeler_Faturalar_FaturaId",
                table: "BudgetOdemeler");

            migrationBuilder.DropIndex(
                name: "IX_BudgetOdemeler_FaturaId",
                table: "BudgetOdemeler");

            migrationBuilder.DropIndex(
                name: "IX_BudgetOdemeler_OdemeYapildigiHesapId",
                table: "BudgetOdemeler");

            migrationBuilder.DropColumn(
                name: "BankaKasaHareketId",
                table: "BudgetOdemeler");

            migrationBuilder.DropColumn(
                name: "FaturaId",
                table: "BudgetOdemeler");

            migrationBuilder.DropColumn(
                name: "FaturaIleKapatildi",
                table: "BudgetOdemeler");

            migrationBuilder.DropColumn(
                name: "GercekOdemeTarihi",
                table: "BudgetOdemeler");

            migrationBuilder.DropColumn(
                name: "OdemeNotu",
                table: "BudgetOdemeler");

            migrationBuilder.DropColumn(
                name: "OdemeYapildigiHesapId",
                table: "BudgetOdemeler");

            migrationBuilder.DropColumn(
                name: "OdenenTutar",
                table: "BudgetOdemeler");
        }
    }
}
