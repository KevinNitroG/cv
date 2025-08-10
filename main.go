package main

import (
	"html/template"
	"os"
	"path/filepath"
)

type PageData struct {
	Files []string
}

func main() {
	var files []string
	err := filepath.Walk("build", func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() {
			fileName := filepath.Base(path)
			files = append(files, fileName)
		}
		return nil
	})
	if err != nil {
		panic(err)
	}

	tmpl := template.Must(template.ParseFiles("templates/index.html"))

	outputFile, err := os.Create("public/index.html")
	if err != nil {
		panic(err)
	}
	defer outputFile.Close()

	data := PageData{Files: files}
	if err := tmpl.Execute(outputFile, data); err != nil {
		panic(err)
	}
}
