using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CRMFiloServis.Web.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddEFaturaFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "EFaturaTipi",
                table: "Faturalar",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "EttnNo",
                table: "Faturalar",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "FaturaYonu",
                table: "Faturalar",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "GibKodu",
                table: "Faturalar",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "GibOnayTarihi",
                table: "Faturalar",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ImportKaynak",
                table: "Faturalar",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "EFaturaTipi",
                table: "Faturalar");

            migrationBuilder.DropColumn(
                name: "EttnNo",
                table: "Faturalar");

            migrationBuilder.DropColumn(
                name: "FaturaYonu",
                table: "Faturalar");

            migrationBuilder.DropColumn(
                name: "GibKodu",
                table: "Faturalar");

            migrationBuilder.DropColumn(
                name: "GibOnayTarihi",
                table: "Faturalar");

            migrationBuilder.DropColumn(
                name: "ImportKaynak",
                table: "Faturalar");
        }
    }
}
